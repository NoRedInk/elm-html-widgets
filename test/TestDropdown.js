var app = Elm.fullscreen(Elm.TestDropdown);

describe('Dropdown', function() {
  describe('basic render', function () {
      it('should render something with the dropdown class', function () {
      assert.equal(document.querySelectorAll(".dropdown").length, 1);
    });
  });
});
