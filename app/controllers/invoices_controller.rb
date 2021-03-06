class InvoicesController < ApplicationController
  unloadable
  skip_before_filter :load_project
  before_filter :load_invoice,  :only => [:show, :preview, :edit, :update, :destroy]
  before_filter :load_project,  :only => [:new]
  before_filter :load_comments, :only => [:new]

  def index
    @invoices = Invoice.all
  end

  def show
  end

  def preview
    render :layout => 'invoice/print'
  end

  def new
    @invoice = Invoice.new_or_from(params[:from], :items => @comments)
  end

  def edit
  end

  def create
    @invoice = Invoice.new(params[:invoice])

    if @invoice.save
      redirect_to invoice_url(@invoice)
    else
      render 'new'
    end
  end

  def update
    if @invoice.update_attributes(params[:invoice])
      redirect_to invoice_url(@invoice)
    else
      render 'edit'
    end
  end

  private

  def load_invoice
    @invoice = Invoice.find(params[:id])
  end

  def load_project
    @project = Project.find_by_id(params[:project_id])
  end

  def load_comments
    #TODO add time scope
    @comments = @project ? @project.comments.with_hours : Comment.with_hours
  end
end
