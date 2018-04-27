class GroupsController < ApplicationController
  def index
    @groups = current_user.groups.all
  end

  def show
    group
  end

  def new
    @group = Group.new
  end

  def edit
    group
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to group_path(@group), notice: "Ryhmä lisätty"
    else
      render :new, alert: "Jotain meni pielee, yritä uudelleen!"
    end
  end

  def update
    if group.update(group_params)
      redirect_to groups_path, notice: "Ryhmä päivitetty"
    else
      render :new, alert: "Jotain meni pielee, yritä uudelleen!"
    end
  end

  def destroy
    group.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Ryhmä poistettu onnistuneesti." }
      format.json { head :no_content }
    end
  end

  private

  def group
    @group ||= current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(
      :name,
      user_ids: [],
      attachments_attributes: [:id, :attachment, :_destroy])
  end
end
