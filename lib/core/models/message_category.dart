class MessageCategory {
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final List<MessageSubCategory> subCategories;
  final String? iconPath;
  final int order;
  final bool isActive;

  const MessageCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    this.subCategories = const [],
    this.iconPath,
    this.order = 0,
    this.isActive = true,
  });

  factory MessageCategory.fromJson(Map<String, dynamic> json) => MessageCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map(
                  (e) => MessageSubCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      iconPath: json['iconPath'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'subCategories': subCategories.map((e) => e.toJson()).toList(),
      'iconPath': iconPath,
      'order': order,
      'isActive': isActive,
    };

  String getLocalizedName(String locale) => locale == 'ar' ? nameAr : name;

  String? getLocalizedDescription(String locale) => locale == 'ar' ? descriptionAr : description;
}

class MessageSubCategory {
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final List<String> templates;
  final int order;
  final bool isActive;

  const MessageSubCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    this.templates = const [],
    this.order = 0,
    this.isActive = true,
  });

  factory MessageSubCategory.fromJson(Map<String, dynamic> json) => MessageSubCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      templates: (json['templates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      order: json['order'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'templates': templates,
      'order': order,
      'isActive': isActive,
    };

  String getLocalizedName(String locale) => locale == 'ar' ? nameAr : name;

  String? getLocalizedDescription(String locale) => locale == 'ar' ? descriptionAr : description;
}

class MessageCategoriesService {
  static List<MessageCategory> _categories = [];
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    _categories = _getDefaultCategories();
    _isInitialized = true;
  }

  static List<MessageCategory> getAllCategories() => _categories.where((category) => category.isActive).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

  static MessageCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<MessageSubCategory> getSubCategories(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.subCategories.where((sub) => sub.isActive).toList() ?? [];
  }

  static List<String> getTemplates(String categoryId, String subCategoryId) {
    final category = getCategoryById(categoryId);
    if (category == null) return [];

    try {
      final subCategory =
          category.subCategories.firstWhere((sub) => sub.id == subCategoryId);
      return subCategory.templates;
    } catch (e) {
      return [];
    }
  }

  static List<MessageCategory> _getDefaultCategories() => [
      MessageCategory(
        id: 'religious',
        name: 'Religious',
        nameAr: 'دينية',
        description: 'Religious greetings and messages',
        descriptionAr: 'تهاني ورسائل دينية',
        order: 1,
        subCategories: [
          MessageSubCategory(
            id: 'eid',
            name: 'Eid',
            nameAr: 'عيد',
            templates: [
              'كل عام وأنتم بخير بمناسبة العيد المبارك',
              'عيد مبارك وكل عام وأنتم بألف خير',
              'أعاده الله عليكم بالخير والبركة',
            ],
          ),
          MessageSubCategory(
            id: 'ramadan',
            name: 'Ramadan',
            nameAr: 'رمضان',
            templates: [
              'رمضان كريم وكل عام وأنتم بخير',
              'بارك الله لكم في شهر رمضان المبارك',
              'أعانكم الله على صيامه وقيامه',
            ],
          ),
        ],
      ),
      MessageCategory(
        id: 'occasions',
        name: 'Occasions',
        nameAr: 'مناسبات',
        description: 'Special occasions and celebrations',
        descriptionAr: 'مناسبات واحتفالات خاصة',
        order: 2,
        subCategories: [
          MessageSubCategory(
            id: 'birthday',
            name: 'Birthday',
            nameAr: 'عيد ميلاد',
            templates: [
              'كل عام وأنت بخير بمناسبة عيد ميلادك',
              'عيد ميلاد سعيد وعقبال مائة سنة',
              'أطال الله في عمرك وبارك في سنينك',
            ],
          ),
          MessageSubCategory(
            id: 'wedding',
            name: 'Wedding',
            nameAr: 'زواج',
            templates: [
              'ألف مبروك الزواج وبالرفاه والبنين',
              'بارك الله لكما وبارك عليكما',
              'عقبال ما نفرح بالذرية الصالحة',
            ],
          ),
        ],
      ),
      MessageCategory(
        id: 'condolences',
        name: 'Condolences',
        nameAr: 'تعازي',
        description: 'Condolence messages',
        descriptionAr: 'رسائل تعزية ومواساة',
        order: 3,
        subCategories: [
          MessageSubCategory(
            id: 'general_condolence',
            name: 'General Condolence',
            nameAr: 'تعزية عامة',
            templates: [
              'إنا لله وإنا إليه راجعون، أحر التعازي والمواساة',
              'عظم الله أجركم وأحسن عزاءكم',
              'البقاء لله وحده، أسأل الله أن يتغمد الفقيد بواسع رحمته',
            ],
          ),
        ],
      ),
      MessageCategory(
        id: 'congratulations',
        name: 'Congratulations',
        nameAr: 'تهاني',
        description: 'Congratulatory messages',
        descriptionAr: 'رسائل تهنئة وتبريك',
        order: 4,
        subCategories: [
          MessageSubCategory(
            id: 'success',
            name: 'Success',
            nameAr: 'نجاح',
            templates: [
              'ألف مبروك النجاح والتفوق',
              'بارك الله لك في نجاحك وإنجازك',
              'عقبال المزيد من النجاحات والإنجازات',
            ],
          ),
          MessageSubCategory(
            id: 'graduation',
            name: 'Graduation',
            nameAr: 'تخرج',
            templates: [
              'ألف مبروك التخرج وبالتوفيق في المستقبل',
              'عقبال الدكتوراه والمناصب العليا',
              'بارك الله لك في شهادتك ووفقك لما فيه الخير',
            ],
          ),
        ],
      ),
    ];
}
