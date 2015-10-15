var app = Elm.fullscreen(Elm.TestAccordion);

describe('Accordion', function() {
  describe('basic render', function () {
    it("should render something with the accordion class", function () {
      assert.equal(document.querySelectorAll(".accordion").length, 1);
    });

    it("should render only the middle entry expanded", function () {
      expectExpanded(1);
    });

    it("should expand the top entry when clicked", function (done) {
      clickOn(document.querySelector(".accordion-entry:nth-child(1) .accordion-entry-header"));
      setTimeout(function() {
        expectExpanded(0);
        done();
      }, 100);
    });

    it("should do nothing when the middle entry is clicked", function (done) {
      clickOn(document.querySelector(".accordion-entry:nth-child(2) .accordion-entry-header"));
      setTimeout(function() {
        expectExpanded(1);
        done();
      }, 100);
    });

    it("should expand the bottom entry when clicked", function (done) {
      clickOn(document.querySelector(".accordion-entry:nth-child(3) .accordion-entry-header"));
      setTimeout(function() {
        expectExpanded(2);
        done();
      }, 100);
    });

    it("should let you click one entry and then another", function (done) {
      clickOn(document.querySelector(".accordion-entry:nth-child(3) .accordion-entry-header"));
      setTimeout(function() {
        expectExpanded(2);

        clickOn(document.querySelector(".accordion-entry:nth-child(1) .accordion-entry-header"));

        setTimeout(function() {
          expectExpanded(0);
          done();
        }, 100);
      }, 100);
    });
  });
});

function expectExpanded(expectedIndex) {
  [].forEach.call(document.querySelectorAll(".accordion-entry"), function(elem, index) {
    var isExpanded = /accordion-entry-state-expanded/.test(elem.className);

    assert.equal((index === expectedIndex), isExpanded,
      "Expected entry at index " + index + " to have expanded = " + (index === expectedIndex) + " but it was " + isExpanded + " instead.");
  });
}

function clickOn(elem) {
    var event = document.createEvent("MouseEvent");

    event.initMouseEvent("click", true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null);
    elem.dispatchEvent(event);
}
