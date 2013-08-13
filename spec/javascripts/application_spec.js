describe("gs.getCopyOfDate", function() {
  it("should make a copy of date", function() {
    date1 = new Date(2013,1,1);
    date2 = gs.getCopyOfDate(date1);

    expect(date2).not.toBe(date1);
    expect(date2.getTime()).toBe(date1.getTime());
  });

  it("should format date", function() {
    expect(gs.formatDate(new Date(2013,1,1))).toBe("2013/2/1");
  });
});
