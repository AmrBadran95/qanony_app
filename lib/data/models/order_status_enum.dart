enum OrderStatus {
  pending,
  acceptedByLawyer,
  rejectedByLawyer,
  paymentRejected,
  paymentDone,
}

OrderStatus orderStatusFromString(String status) {
  switch (status) {
    case "accepted_by_lawyer":
      return OrderStatus.acceptedByLawyer;
    case "rejected_by_lawyer":
      return OrderStatus.rejectedByLawyer;
    case "payment_rejected":
      return OrderStatus.paymentRejected;
    case "payment_done":
      return OrderStatus.paymentDone;
    default:
      return OrderStatus.pending;
  }
}

String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return "pending";
    case OrderStatus.acceptedByLawyer:
      return "accepted_by_lawyer";
    case OrderStatus.rejectedByLawyer:
      return "rejected_by_lawyer";
    case OrderStatus.paymentRejected:
      return "payment_rejected";
    case OrderStatus.paymentDone:
      return "payment_done";
  }
}
