const ruleCatalogue = [
  {
    'name': 'Play Count',
    'conditions': ['compare', 'intValue'],
    'active': true
  },
  {
    'name': 'Total Duration',
    'conditions': ['duration'],
    'active': false
  }
];

const conditionCatalogue = {
  'compare': {
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
