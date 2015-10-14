var app = Elm.fullscreen(Elm.TestAccordion);

describe('Accordion', function() {
  describe('basic render', function () {
      it('should render something with the accordion class', function () {
      assert.equal(document.querySelectorAll(".accordion").length, 1);
    });
  });
});
