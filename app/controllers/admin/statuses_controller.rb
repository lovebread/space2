class Admin::StatusesController < AdminBaseController

  def index
    @statuses = Status.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @statuses = Status.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @statuses = Status.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    #@status.verified = 1
    if @status.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    #@status.verified = 2
    if @status.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @status = Status.find(params[:id])
    end
  rescue
    not_found
  end
  
end
