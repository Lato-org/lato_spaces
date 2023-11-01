module LatoSpaces
  class SpacesController < ApplicationController
    before_action :find_space, only: %i[edit update destroy]

    def index
      columns = %i[name members actions]
      sortable_columns = %i[name]
      searchable_columns = %i[name]

      @spaces = lato_index_collection(
        LatoSpaces::Space.all,
        columns: columns,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_sort_by: 'name|ASC',
        pagination: true
      )
    end

    def new
      @space = LatoSpaces::Space.new
    end

    def create
      @space = LatoSpaces::Space.new(space_params.merge(
        lato_user_creator_id: @session.user_id
      ))
      return render :new unless @space.save

      redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly created.'
    end

    def edit
    end

    def update
      return render :edit unless @space.update(space_params)

      redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly updated.'
    end

    def destroy
      @space.destroy
      redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly destroyed.'
    end

    private

    def space_params
      params.require(:space).permit(:name)
    end

    def find_space
      @space = LatoSpaces::Space.find(params[:id])
    end
  end
end
