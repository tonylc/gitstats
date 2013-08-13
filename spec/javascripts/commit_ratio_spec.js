describe('CommitRatio', function() {
  it('should get ratio of 0 if only commited src lines', function() {
    expect(new CommitRatio(1, new Date(2013,1,1), 15, 0).getRatio()).toBe(0);
  });

  it('should get ratio of 1 if only commited test lines', function() {
    expect(new CommitRatio(1, new Date(2013,1,1), 0, 23).getRatio()).toBe(1);
  });

  it('should get ratio test / (src + test)', function() {
    expect(new CommitRatio(1, new Date(2013,1,1), 10, 10).getRatio()).toBe(0.5);
  });

  it('should have a radius that is the suare root of total lines', function() {
    expect(new CommitRatio(1, new Date(2013,1,1), 50, 50).radius()).toBe(10);
  });
});
