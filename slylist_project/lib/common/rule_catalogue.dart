
const ruleCatalogue = [
  {
    'name': 'Play Count',
    'conditions': ['compare', 'intValue'],
    'info':''
  },
  {
    'name': 'Total Duration',
    'conditions': ['intValue'],
    'info':'Some information for total duration'
  }
];

const conditionOptions = {
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
