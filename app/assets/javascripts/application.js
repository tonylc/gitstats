var gs = gs || {
  getCopyOfDate: function(d) {
    return new Date(d.getTime());
  },
  formatDate: function(d) {
    var day = d.getDate();
    var m = d.getMonth() + 1; // Months are zero based
    var y = d.getFullYear();
    return (y + "/" + m + "/" + day);
  },
  determineTimeInterval: function(numDays) {
    if (numDays < 30) {
      return d3.time.days;
    } else {
      return d3.time.months;
    }
  }
};
