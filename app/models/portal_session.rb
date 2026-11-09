class PortalSession
  def initialize(session)
    @session = session
  end

  def read(siret)
    portals.fetch(siret, {})
  end

  def write(siret, params)
    values = params.permit(:external_id, :redirect_uri).compact_blank.to_h
    return if values.empty?

    @session["portals"] = portals.deep_merge(siret => values)
  end

  def kept_after_reset(siret)
    values = read(siret).slice("redirect_uri")
    values.empty? ? {} : {"portals" => {siret => values}}
  end

  private

  def portals
    @session.fetch("portals", {})
  end
end
