module Smithy
  class AssetsDatatable
    include AssetsHelper
    delegate :params, :link_to, :image_tag, :number_to_human_size, :attachment_url, :attachment_image_tag, :file_type_icon, :check_box_tag, :render, to: :@view

    def initialize(view)
      @view = view
    end

    def as_json(options = {})
      {
        draw: params[:draw].to_i,
        recordsTotal: Asset.count,
        recordsFiltered: assets.total_count,
        data: data
      }
    end

    def new_row(assets)
      assets.map do |asset|
        render_asset(asset)
      end
    end

  private

    def data
      assets.map do |asset|
        render_asset asset
      end
    end

    def render_asset(asset)
      [
        check_box_tag('ids[]', asset.id, false, class: "delete"),
        asset_preview_link(asset),
        asset.name,
        number_to_human_size(asset.file_size),
        asset.file_content_type,
        "#{render(partial: '/smithy/assets/actions', formats: :html, locals: { asset: asset })}"
      ]
    end

    def assets
      @assets ||= fetch_assets
    end

    def fetch_assets
      assets = Asset.unscoped.order("#{sort_column} #{sort_direction}")
      assets = assets.page(page).per(per_page)
      # TODO: need to check for regex flag
      if params[:search][:value].present?
        assets = assets.where("name like :search or content_type like :search", search: "%#{params[:search][:value]}%")
      end
      assets
    end

    def page
      params[:start].to_i/per_page + 1
    end

    def per_page
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def sort_column
      columns = %w[delete preview name file_size file_content_type actions]
      columns[params[:order][:"0"][:column].to_i]
    end

    def sort_direction
      params[:order][:"0"][:dir] == "desc" ? "desc" : "asc"
    end
  end
end