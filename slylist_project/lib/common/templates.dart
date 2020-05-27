const List<Map<String, dynamic>> templatePlaylistsJson = [
  {
    "name": "Long Songs I played once",
    "description": "This is a awesome template for some awesome people",
    "sources": ["Complete Library"],
    "groups": [
      {
        "rules": [
          {
            "id": "0",
            "name": "Play Count",
            "conditions": [
              {"type": "compare", "value": "is"},
              {"type": "intValue", "value": "1"}
            ]
          },
          {
            "id": "1",
            "name": "Total Duration",
            "conditions": [
              {"type": "intValue", "value": "180"}
            ]
          }
        ],
        "match": "MATCH ALL"
      }
    ],
    "groupsMatch": "MATCH ANY",
    "songLimit": null,
    "sort": "Most Played",
    "isPublic": true,
    "isSynced": true
  }
];
