import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/services/fuelio_import.dart';

const _csv = '''
"## Vehicle"
"Name","Description","DistUnit","FuelUnit","ConsumptionUnit","ImportCSVDateFormat","VIN","Insurance","Plate","Make","Model","Year","TankCount","Tank1Type","Tank2Type","Active","Tank1Capacity","Tank2Capacity","FuelUnitTank2","FuelConsumptionTank2","guid","lastupdated"
"Renault Scenic","2018 kupene","0","0","0","yyyy-MM-dd","","","BA123XY","Renault","Scenic","2010","1","100","0","1","60.0","0.0","0","0","veh-guid","1"
"## Log"
"Data","Odo (km)","Fuel (litres)","Full","Price (optional)","l/100km (optional)","latitude (optional)","longitude (optional)","City (optional)","Notes (optional)","Missed","TankNumber","FuelType","VolumePrice","StationID (optional)","ExcludeDistance","UniqueId","TankCalc","Weather","guid","lastupdated"
"2026-10-21 19:36","175084.0","50.0","1","93.0","9.35","48.77904","18.60845","Prievidza - Tesco","","0","1","110","1.86","120785","0.0","122","0.0",,"fill-2","1"
"2026-09-27 16:27","174549.0","45.0","1","83.66","10.2","48.77734","18.60133","GPS","","0","1","110","1.859","805888","0.0","121","0.0",,"fill-1","1"
"## CostCategories"
"CostTypeID","Name","priority","color","guid","lastupdated"
"2","Údržba","0","#673AB7","cat-2","1"
"32","STK/EK","0","#E91E63","cat-32","1"
"## Costs"
"CostTitle","Date","Odo","CostTypeID","Notes","Cost","flag","idR","read","RemindOdo","RemindDate","isTemplate","RepeatOdo","RepeatMonths","isIncome","UniqueId","guid","lastupdated"
"STK a EK","2026-10-16","0","32","končí STK a EK","0.0","0","0","0","0","2028-10-16","0","0","24","0","48","cost-1","1"
"olej, filtre","2026-07-21 12:13","174000","2","","320.0","0","0","1","0","2011-01-01","0","0","0","0","65","cost-2","1"
"## FavStations"
"NameBrand","Latitude","Longitude","StationID","Description","CountryCode","guid","lastupdated"
"Shell PD","48.77727","18.60139","311543","Shell PD","SVK","station-1","1"
"## Category"
"IdCategory","Name","guid","lastupdated"
"1","Súkromné","category-1","1"
"## TripLog"
"title","StartName","StartLat","StartLong","StartDate","StartOdo","EndName","EndLat","EndLong","EndDate","EndOdo","TripCost","TripCategory","TripCostKm","TripNote","TripDist","TripLogFile","TripAvgSpeed","TripTopSpeed","TripDuration","TripShowLog","guid","lastupdated"
"Ranná jazda","GPS","48.78","18.62","2020-05-12 07:28","0.0","GPS","48.77","18.61","2020-05-12 07:30","0.0","0.14","1","0.1","","1326","1589261217220","9.0","13.2","146","0","trip-1","1"
''';

void main() {
  group('FuelioImporter.parse', () {
    final preview = FuelioImporter.parse(_csv);

    test('reads the vehicle', () {
      expect(preview.vehicle.name, 'Renault Scenic');
      expect(preview.vehicle.plate, 'BA123XY');
      expect(preview.vehicle.make, 'Renault');
      expect(preview.vehicle.year, 2010);
      expect(preview.vehicle.tankCapacity, 60);
      expect(preview.vehicle.fuelType, 'petrol95');
      expect(preview.vehicle.initialOdometer, 174549);
    });

    test('reads fill-ups with station and coordinates', () {
      expect(preview.fillUps, hasLength(2));
      final newest = preview.fillUps.first;
      expect(newest.odometer, 175084);
      expect(newest.liters, 50);
      expect(newest.totalPrice, 93);
      expect(newest.pricePerLiter, 1.86);
      expect(newest.stationName, 'Prievidza - Tesco');
      expect(newest.latitude, closeTo(48.77904, 0.00001));
      expect(newest.externalId, 'fill-2');
      expect(preview.fillUps.last.stationName, isEmpty); // "GPS" placeholder
    });

    test('uses the earliest odometer as the initial value', () {
      expect(preview.vehicle.initialOdometer, 174549);
    });

    test('maps costs to expenses and reminders', () {
      expect(preview.expenses, hasLength(1));
      expect(preview.expenses.single.title, 'olej, filtre');
      expect(preview.expenses.single.amount, 320);
      expect(preview.expenses.single.categoryKey, 'maintenance');
      expect(preview.expenses.single.odometer, 174000);

      expect(preview.reminders, hasLength(1));
      final reminder = preview.reminders.single;
      expect(reminder.title, 'STK a EK');
      expect(reminder.dueDate, DateTime(2028, 10, 16));
      expect(reminder.repeatMonths, 24);
      expect(reminder.categoryKey, 'inspection');
    });

    test('skips the 2011-01-01 reminder sentinel', () {
      expect(preview.reminders, hasLength(1));
    });

    test('keeps favourite stations and counts trips', () {
      expect(preview.stations.single.name, 'Shell PD');
      expect(preview.tripsSkipped, 1);
    });

    test('rejects files without the vehicle section', () {
      expect(
        () => FuelioImporter.parse('"## Log"\n"Data"\n"2026-01-01"'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
