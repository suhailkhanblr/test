class MembershipPlan {
  bool isSelected;
  String id;
  String title;
  bool recommended;
  String price;
  String payMode;
  String image;
  String term;
  String limit;
  String duration;
  String featuredFee;
  String urgentFee;
  String highlightFee;
  String featuredDuration;
  String urgentDuration;
  String highlightDuration;
  bool topSearchResult;
  bool showOnHome;
  bool showInHomeSearch;

  MembershipPlan({
    required this.isSelected,
    required this.id,
    required this.title,
    required this.recommended,
    required this.price,
    required this.payMode,
    required this.image,
    required this.term,
    required this.limit,
    required this.duration,
    required this.featuredFee,
    required this.urgentFee,
    required this.highlightFee,
    required this.featuredDuration,
    required this.urgentDuration,
    required this.highlightDuration,
    required this.topSearchResult,
    required this.showOnHome,
    required this.showInHomeSearch,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      isSelected: json['Selected'] == 1 ? true : false,
      id: json['id'],
      title: json['title'],
      recommended: json['recommended'] == 'yes' ? true : false,
      price: json['cost'],
      payMode: json['pay_mode'],
      image: json['image'],
      term: json['term'],
      limit: json['limit'],
      duration: json['duration'],
      featuredFee: json['featured_fee'],
      urgentFee: json['urgent_fee'],
      highlightFee: json['highlight_fee'],
      featuredDuration: json['featured_duration'],
      urgentDuration: json['urgent_duration'],
      highlightDuration: json['highlight_duration'],
      topSearchResult: json['top_search_result'] == 'yes' ? true : false,
      showOnHome: json['show_on_home'] == 'yes' ? true : false,
      showInHomeSearch: json['show_in_home_search'] == 'yes' ? true : false,
    );
  }
}
