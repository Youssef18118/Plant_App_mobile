class OnboardingModel {
  String? title;
  String? image;
  String? mess1;
  String? elipse;

  OnboardingModel({
    this.image,
    this.title,
    this.mess1,
    this.elipse,
  });
}

List<OnboardingModel> onBoardingList = [
  OnboardingModel(
    title: "Browse Plants",
    image: "Pic1.png",
    mess1: "You can browse the plants you can add to your Garden ",
    elipse: "elipse1.PNG",
  ),
  OnboardingModel(
      title: "Care For Any Plant",
      image: "Pic2.png",
      mess1:
          "Let's learn how to care for any plant species that exist in this world",
      elipse: "elipse2.PNG"),
  OnboardingModel(
      title: "Read Many Articles About Plant",
      image: "Pic3.png",
      mess1:
          "Let's learn more about beautiful plants and read many articles about plants and gardening",
      elipse: "elipse3.PNG"),
];
