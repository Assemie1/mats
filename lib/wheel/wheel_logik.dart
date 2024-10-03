class WheelLogic {
  List<String> inputArray = [];
  saveValue(input){
    inputArray.add(input);
    print(inputArray);
  }

   void reset(){
    inputArray = [];
  }

}