
import 'package:slylist_project/common/enums.dart';

const ruleCatalogue = [
  {
    'name': 'Play Count',
    'conditions': [Conditions.compare, Conditions.intValue],
    'info':''
  },
  {
    'name': 'Total Duration',
    'conditions': [Conditions.intValue],
    'info':'Some information for total duration'
  }
];

const conditionOptions = {
  Conditions.compare: {
    'options': <String>[
      'is',
      'is not',
      'greater than what ever long text',
      'less than',
      'is at least',
      'is at most'
    ]
  }
};
