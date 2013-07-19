describe("Stat", function() {
  var stat;

  beforeEach(function() {
    stat = new Stat(new Date(2013,1,1), 1, 2);
  });

  it("should add changed lines", function() {
    stat.addToPlusCount(3);
    expect(stat.added).toBe(4);
    stat.addToPlusCount(5);
    expect(stat.added).toBe(9);
  });

  it("should add deleted lines", function() {
    stat.addToMinusCount(1);
    expect(stat.deleted).toBe(3);
    stat.addToMinusCount(2);
    expect(stat.deleted).toBe(5);
  });

  it("should add changed + deleted to be total lines", function() {
    stat.addToPlusCount(3);
    stat.addToMinusCount(1);
    stat.addToPlusCount(5);
    stat.addToMinusCount(2);
    expect(stat.totalLines()).toBe(14);
  });
});

describe("CommitByDate", function() {
  var commitByDate;

  beforeEach(function() {
    commitByDate = new CommitByDate(new Date(2013,1,1), {"css": "16,0", "html": "334,241", "js": "18,0", "rb": "415,0"});
  });

  describe("#convertLanguageTypeToLanguageText", function() {
    it("should convert recognized language types", function() {
      expect(commitByDate.convertLanguageTypeToLanguageText("rb")).toBe("Ruby");
      expect(commitByDate.convertLanguageTypeToLanguageText("html")).toBe("HTML");
      expect(commitByDate.convertLanguageTypeToLanguageText("css")).toBe("CSS");
      expect(commitByDate.convertLanguageTypeToLanguageText("js")).toBe("Javascript");
      expect(commitByDate.convertLanguageTypeToLanguageText("dunno")).toBe("Unknown");
    });
  });
});
