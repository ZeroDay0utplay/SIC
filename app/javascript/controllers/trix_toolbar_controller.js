import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trix-toolbar"
export default class extends Controller {
  connect() {

    Trix.config.toolbar.getDefaultHTML = toolbarDefaultHTML;

    document.addEventListener('trix-initialize', updateToolbars, { once: true });

    function updateToolbars(event) {
      const toolbars = document.querySelectorAll('trix-toolbar');
      const html = Trix.config.toolbar.getDefaultHTML();
      toolbars.forEach((toolbar) => (toolbar.innerHTML = html));
    }

    function toolbarDefaultHTML() {
      const { lang } = Trix.config;
      return `
      <div class="trix-button-row justify-content-start">
        <span class="trix-button-group m-0 p-0 trix-button-group--text-tools" data-trix-button-group="text-tools">
          <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1">
            ${lang.bold}
            <%= inline_svg_tag('icons/text--bold.svg') %>
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1">
            ${lang.italic}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="${lang.strike}" tabindex="-1">
            ${lang.strike}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="${lang.heading1}" tabindex="-1">
            ${lang.heading1}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="${lang.quote}" tabindex="-1">
            ${lang.quote}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="${lang.code}" tabindex="-1">
            ${lang.code}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1">
            ${lang.bullets}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1">
            ${lang.numbers}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="${lang.outdent}" tabindex="-1">
            ${lang.outdent}
          </button>
          <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="${lang.indent}" tabindex="-1">
            ${lang.indent}
          </button>
        </span>
      </div>
    `;
    }

}
}
