const ruleCatalogue = [
  {
    'name': 'Play Count',
    'conditions': ['compare', 'intValue'],
    'info': ''
  },
  {
    'name': 'Days Added',
    'conditions': ['compare', 'days'],
    'info': 'When was the track added.'
  },
  {
    'name': 'Total Duration',
    'conditions': ['intValue'],
    'info': 'Some information for total duration'
  }
];

const conditionOptions = {
  'compare': {
    'options': <String>[
      'is',
      'is not',
      'greater than',
      'less than',
      'is at least',
      'is at most'
    ]
  }
};
