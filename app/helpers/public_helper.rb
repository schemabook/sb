module PublicHelper
  def render_header
    if homepage?
      render 'layouts/public_homepage_header'
    else
      render 'layouts/public_header'
    end
  end

  def render_footer
    if homepage?
      render 'layouts/public_homepage_footer'
    else
      render 'layouts/public_footer'
    end
  end

  def homepage?
    params[:controller] == 'public' && params[:action] == 'index'
  end
end
