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
