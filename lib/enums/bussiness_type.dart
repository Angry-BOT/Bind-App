enum BussinessType { Service, Product, Both }

BussinessType getBussinessType(String value){
  switch (value) {
    case "Product":
      return BussinessType.Product;
    case "Both":
      return BussinessType.Both;
    default:
      return BussinessType.Service;
  }
}
