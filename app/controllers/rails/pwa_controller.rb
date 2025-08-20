module Rails
  class PwaController < ApplicationController
    def manifest
      render :manifest, formats: :json
    end

    def service_worker
      render :service_worker, formats: :js
    end
  end
end


