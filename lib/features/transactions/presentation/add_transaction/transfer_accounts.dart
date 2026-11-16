({String from, String to}) applyTransferPick({
  required bool from,
  required String picked,
  required String fromId,
  required String toId,
}) {
  var newFrom = fromId;
  var newTo = toId;
  final other = from ? toId : fromId;
  final current = from ? fromId : toId;
  if (picked == other) {
    if (from) {
      newTo = current;
    } else {
      newFrom = current;
    }
  }
  if (from) {
    newFrom = picked;
  } else {
    newTo = picked;
  }
  return (from: newFrom, to: newTo);
}