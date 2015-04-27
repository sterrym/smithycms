module Smithy
  class AssetsDatatable
    delegate :params, :link_to, :image_tag, :number_to_human_size, :file_type_icon, to: :@view

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

  private

    def data
      assets.map do |asset|
        [
          preview_link(asset),
          asset.name,
          number_to_human_size(asset.file_size),
          "#{link_to "Edit", [:edit, asset], class: "btn btn-primary btn-xs"} #{link_to "Delete", asset, class: "btn btn-danger btn-xs", method: :delete, data: { confirm: "Are you sure?" }}"
        ]
      end
    end

    def assets
      @assets ||= fetch_assets
    end

    def fetch_assets
      assets = Asset.unscoped.order("#{sort_column} #{sort_direction}")
      assets = assets.page(page).per(per_page)
      # TODO: need to check for regex flag
      if params[:search][:value].present?
        assets = assets.where("name like :search", search: "%#{params[:search][:value]}%")
      end
      assets
    end

    def preview_link(asset)
      link_to asset.file.remote_url do
        if asset.file_type == :image
          image_tag asset.file.thumb("48x48").url, width: 48, alt: ''
        elsif asset.file_type == :direct_image
          image_tag asset.file.remote_url, width: 48, alt: ''
        else
          image_tag file_type_icon(asset), alt: ''
        end
      end
    end

    def page
      params[:start].to_i/per_page + 1
    end

    def per_page
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def sort_column
      columns = %w[preview name file_size actions]
      columns[params[:order][:"0"][:column].to_i]
    end

    def sort_direction
      params[:order][:"0"][:dir] == "desc" ? "desc" : "asc"
    end
  end
end