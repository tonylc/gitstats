function CommitRatio(authorId, date, srcLines, testLines) {
  this.authorId = authorId;
  this.date = date;
  this.srcLines = srcLines;
  this.testLines = testLines;
}

// test / (src + test)
// 0 = no test
// 1 = only test
CommitRatio.prototype.getRatio = function() {
  return this.testLines / (this.srcLines + this.testLines);
}

CommitRatio.prototype.radius = function() {
  return Math.sqrt(this.srcLines + this.testLines);
}

function Author(id, name, color) {
  this.id = id;
  this.name = name;
  this.color = color || '#000';
}
