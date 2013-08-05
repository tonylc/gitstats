// stats for all commits for a particular language on a given date
function Stat(date, added, deleted) {
  this.date = date;
  this.added = added;
  this.deleted = deleted;
}

Stat.prototype.totalLines = function() {
  return this.added + this.deleted;
}

Stat.prototype.addToPlusCount = function(count) {
  this.added += count;
}

Stat.prototype.addToMinusCount = function(count) {
  this.deleted += count;
}

// all commits for a given user for a specified language
function LanguageCommits(type, statsArr) {
  this.type = type;
  this.statsArr = statsArr;
  this.stats = null;
  this.maxLines = 0;
  this.visible = true;
}

LanguageCommits.prototype.initializeStats = function(numDays, lastDate) {
  var self = this;
  this.stats = $.map(new Array(numDays), function(el, i) {
    var d = gs.getCopyOfDate(lastDate);
    d.setDate(d.getDate()-i);
    return new Stat(d,0,0);
  });
  $.each(self.statsArr, function(i, el) {
    var lastDate = gs.getCopyOfDate(chart.maxDate);
    var date = new Date(el[0]);
    var timeInMillis = lastDate.getTime() - date.getTime();
    var daysAgo = Math.ceil(timeInMillis / (1000 * 60 * 60 * 24));
    self.stats[daysAgo].addToPlusCount(el[1]);
    self.stats[daysAgo].addToMinusCount(el[2]);
    // determine most lines in a day and add 10% to buffer
    if (self.stats[daysAgo].totalLines() > self.maxLines) {
      self.maxLines = Math.ceil(self.stats[daysAgo].totalLines() * 1.1);
    }
  });
  this.stats.reverse();
}

function CommitType(langType, added, deleted) {
  this.langType = langType;
  this.added = parseInt(added);
  this.deleted = parseInt(deleted);
  this.total = parseInt(added) + parseInt(deleted);
}

// all commits for a given user for a given date
function CommitByDate(date, statsHash) {
  this.date = gs.getCopyOfDate(date);
  this.statsHash = statsHash;
  this.commitTypes = [];
  var self = this;
  $.each(statsHash, function(langType, countStr) {
    self.commitTypes.push(new CommitType(langType, countStr.split(",")[0], countStr.split(",")[1]));
  });
}

CommitByDate.prototype.languageStr = function() {
  var self = this;
  return $.map(this.commitTypes, function(el, i) {
    if (!chart.languageToCommit[el.langType].visible) {
      return '';
    }
    return '<span class="' + el.langType + ' lang-type">' + self.convertLanguageTypeToLanguageText(el.langType) + '</span>' + ": " + el.total;
  }).join(" ");
}

CommitByDate.prototype.convertLanguageTypeToLanguageText = function(langType) {
  switch(langType) {
    case "rb":
      return "Ruby";
    case "html":
      return "HTML";
    case "css":
      return "CSS";
    case "js":
      return "Javascript";
    default:
      return "Unknown";
  }
}
