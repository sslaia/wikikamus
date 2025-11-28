class SliderModel {
  String imageAssetPath;
  String title;
  String description;

  SliderModel({
    required this.imageAssetPath,
    required this.title,
    required this.description,
  });
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/wikikamus-nusantara.webp",
      title: "onboarding1_title",
      description: "onboarding1_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/dark-mode.webp",
      title: "onboarding2_title",
      description: "onboarding2_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/search.webp",
      title: "onboarding3_title",
      description: "onboarding3_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/search-create.webp",
      title: "onboarding4_title",
      description: "onboarding4_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/share-edit.webp",
      title: "onboarding5_title",
      description: "onboarding5_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/community-shortcuts.webp",
      title: "onboarding6_title",
      description: "onboarding6_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/settings.webp",
      title: "onboarding7_title",
      description: "onboarding7_desc",
    ),
  );

  slides.add(
    SliderModel(
      imageAssetPath: "assets/images/warning.webp",
      title: "onboarding8_title",
      description: "onboarding8_desc",
    ),
  );

  return slides;
}
