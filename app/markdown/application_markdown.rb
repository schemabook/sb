# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

require 'rouge'

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  # Reformats your boring punctation like " and " into “ and ” so you can look
  # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  include Redcarpet::Render::SmartyPants

  FORMATTER = Rouge::Formatters::HTML.new("github")
  
  # If you need access to ActionController::Base.helpers, you can delegate by uncommenting
  # and adding to the list below. Several are already included for you in the `MarkdownRails::Renderer::Rails`,
  # but you can add more here.
  #
  # To see a list of methods available run `bin/rails runner "puts ActionController::Base.helpers.public_methods.sort"`
  #
  # delegate \
  #   :request,
  #   :cache,
  #   :turbo_frame_tag,
  # to: :helpers

  # These flags control features in the Redcarpet renderer, which you can read
  # about at https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
  # Make sure you know what you're doing if you're using this to render user inputs.
  def enable
    [:fenced_code_blocks]
  end

  # NOTE: available methods are listed here: https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
  # block_code(code, language)
  # block_quote(quote)
  # block_html(raw_html)
  # footnotes(content)
  # footnote_def(content, number)
  # header(text, header_level)
  # hrule()
  # list(contents, list_type)
  # list_item(text, list_type)
  # paragraph(text)
  # table(header, body)
  # table_row(content)
  # table_cell(content, alignment, header)
  # 
  # Span-level calls
  # A return value of nil will not output any data. If the method for a document element is not implemented, the contents of the span will be copied verbatim:
  # 
  # autolink(link, link_type)
  # codespan(code)
  # double_emphasis(text)
  # emphasis(text)
  # image(link, title, alt_text)
  # linebreak()
  # link(link, title, content)
  # raw_html(raw_html)
  # triple_emphasis(text)
  # strikethrough(text)
  # superscript(text)
  # underline(text)
  # highlight(text)
  # quote(text)
  # footnote_ref(number)
  # 
  # Note: When overriding a renderer's method, be sure to return a HTML element with a level that matches the level of that method (e.g. return a block element when overriding a block-level callback). Otherwise, the output may be unexpected.
  # entity(text)
  # normal_text(text)

  def block_code(code, language)
    lexer = Rouge::Lexer.find(language)
    if lexer.nil?
      lexer = Rouge::Lexer.find("json")
    end

    content_tag :pre, class: "#{language} mb-6 border", style: "background-color: #f6f8fa;" do
      raw FORMATTER.format(lexer.lex(code))
    end
  end

  def paragraph(text)
    %(<p class="p-8 mb-6">#{text}</p>)
  end

  def header(headline, level)
    %(<h#{level} class="mb-6 flex-none font-medium text-gray-1000 group-hover:text-teal-600 group-hover:underline">#{headline}</h#{level}>)
  end

  def link(link, title, content)
    %(<a href="#{link}" class="space-x-4 group"><span class="flex-none font-medium underline text-slate-300 group-hover:text-teal-600 group-hover:underline">#{content}</span></a>)
  end

  def list(contents, list_type)
    %(<ul class="list-disc px-8 mb-6" style="list-style-type: disc;">#{contents}</ul>)
  end

  def list_item(text, list_type)
    %(<li>#{text}</li>)
  end

  def block_quote(quote)
    %(<blockquote class="p-4 my-4 bg-gray-50 border-l-4 border-gray-300"><p class="text-xl italic font-medium leading-relaxed text-gray-900">"#{quote}"</p> </blockquote>)
  end

  # Example of how you might override the images to show embeds, like a YouTube video.
  # def image(link, title, alt)
  #   url = URI(link)
  #   case url.host
  #   when "www.youtube.com"
  #     youtube_tag url, alt
  #   else
  #     super
  #   end
  # end

  private
    # This is provided as an example; there's many more YouTube URLs that this wouldn't catch.
    def youtube_tag(url, alt)
      embed_url = "https://www.youtube-nocookie.com/embed/#{CGI.parse(url.query).fetch("v").first}"
      content_tag :iframe,
        src: embed_url,
        width: 560,
        height: 325,
        allow: "encrypted-media; picture-in-picture",
        allowfullscreen: true \
          do alt end
    end
end
