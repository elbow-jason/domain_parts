defmodule DomainParts do

  @protocol_regex ~r/^.*\/\//

  defstruct [
    tld:        nil,
    domain:     nil,
    subdomain:  nil,
  ]

  def new(url) when url |> is_binary do
    url
    |> add_protocol
    |> URI.parse
    |> new
  end
  def new(%URI{host: host}) when host |> is_binary do
    case host |> PublicSuffex.parse do
      tld when tld |> is_binary ->
        {subdomain, domain} = host
          |> remove_tld(tld)
          |> to_parts
        new(subdomain, domain, tld)
      _ ->
        {:error, :invalid_url}
    end
  end
  def new(subdomain, domain, tld) do
    %DomainParts{
      subdomain:  subdomain,
      domain:     domain,
      tld:        tld,
    }
  end

  def to_string(%DomainParts{} = url) do
    [url.subdomain, url.domain, url.tld]
    |> Enum.filter(fn
      ""   -> false
      item -> item
    end)
    |> Enum.join(".")
  end

  defp to_parts(string) when string |> is_binary do
    string
    |> String.split(".")
    |> to_parts
  end
  defp to_parts(list) when list |> is_list do
    [domain | subdomain] = list |> Enum.reverse
    {subdomain |> assemble_subdomain, domain}
  end

  defp remove_tld(site, tld) do
    dot_tld = "." <> tld
    site
    |> String.split(dot_tld)
    |> Enum.filter(fn
      "" -> false
      _  -> true
    end)
    |> Enum.join(dot_tld)
  end

  defp add_protocol(domain) when domain |> is_binary do
    "http://" <> Regex.replace(@protocol_regex, domain, "")
  end

  defp assemble_subdomain(subdomain) do
    case subdomain do
      list when list |> is_list ->
        list
        |> Enum.reverse
        |> Enum.join(".")
      "" <> string ->
        string
      _ ->
        nil
    end
  end

end

defimpl String.Chars, for: DomainParts do
  def to_string(%DomainParts{} = domain_parts) do
    domain_parts
    |> DomainParts.to_string
  end
end
