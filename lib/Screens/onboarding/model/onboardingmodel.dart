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
    title: "Identify Plants",
    image: "Pic1.png",
    mess1: "You can identify the plants you don't know through your camera ",
    elipse: "elipse1.PNG",
  ),
  OnboardingModel(
      title: "Learn Many Plants Species",
      image: "Pic2.png",
      mess1:
          "Let's learn about the many plant species that exist in this world",
      elipse: "elipse2.PNG"),
  OnboardingModel(
      title: "Read Many Articles About Plant",
      image: "Pic3.png",
      mess1:
          "Let's learn more about beautiful plants and read many articles about plants and gardening",
      elipse: "elipse3.PNG"),
];
