enum Status {Pending, Active, Banned }

Status getStatus(String value) {
  switch (value) {
    case "Active":
      return Status.Active;
        case "Banned":

      return Status.Banned;
    
    default:
      return Status.Pending;
  }
}