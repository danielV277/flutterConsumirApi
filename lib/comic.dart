class Comic{
  final int id;
  final String title;
  final int issueNumber;
  final int pageCount;

  Comic({
    required this.id,
    required this.title,
    required this.issueNumber,
    required this.pageCount,
  });

  factory Comic.fromJson(Map<String, dynamic> json){
    return Comic(
      id: json['id'],
      title: json['title'],
      issueNumber: json['issueNumber'],
      pageCount: json['pageCount']
    );
  }
}
