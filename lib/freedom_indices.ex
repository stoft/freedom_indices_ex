defmodule FreedomIndices do
  @moduledoc """
  Documentation for FreedomIndices.
  """
  @freedomhouse_org_json_file "priv/freedomhouse.org.2019.json"
  @freedomhouse_org_json File.read!(@freedomhouse_org_json_file)
  @freedomhouse_org_dataset Jason.decode!(@freedomhouse_org_json)

  @freedomhouse_org_dataset_alpha_2 @freedomhouse_org_dataset
                                    |> Enum.filter(fn x -> x["type"] == "country" end)
                                    |> Enum.reduce(%{}, fn x, acc ->
                                      Map.put(acc, x["iso_country_code_alpha_2"], x)
                                    end)

  @freedomhouse_org_dataset_alpha_3 @freedomhouse_org_dataset
                                    |> Enum.filter(fn x -> x["type"] == "country" end)
                                    |> Enum.reduce(%{}, fn x, acc ->
                                      Map.put(acc, x["iso_country_code_alpha_3"], x)
                                    end)

  @freedomhouse_org_dataset_name @freedomhouse_org_dataset
                                 |> Enum.filter(fn x -> x["type"] == "country" end)
                                 |> Enum.reduce(%{}, fn x, acc ->
                                   Map.put(acc, x["name"], x)
                                 end)
  @doc """
  Gets the freedom index entry for a country based on ISO-3166 alpha 2 country codes.

  ## Examples

      iex> FreedomIndices.get_country_by_iso_alpha_2("SE")
      %{
          "aggregate_score" => 100,
          "civil_liberties_rating" => 1,
          "combined_score" => 1,
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/report/freedom-world/2019/sweden",
          "type" => "country"
        }

  """
  def get_country_by_iso_alpha_2(country_code, source \\ "freedomhouse.org")

  def get_country_by_iso_alpha_2(country_code, "freedomhouse.org") do
    Map.get(@freedomhouse_org_dataset_alpha_2, country_code)
  end

  @doc """
  Gets the freedom index entry for a country based on ISO-3166 alpha 3 country codes.

  ## Examples

      iex> FreedomIndices.get_country_by_iso_alpha_3("SWE")
      %{
          "aggregate_score" => 100,
          "civil_liberties_rating" => 1,
          "combined_score" => 1,
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/report/freedom-world/2019/sweden",
          "type" => "country"
        }

      iex> FreedomIndices.get_country_by_iso_alpha_3("SWE", "freedomhouse.org")
      %{
          "aggregate_score" => 100,
          "civil_liberties_rating" => 1,
          "combined_score" => 1,
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/report/freedom-world/2019/sweden",
          "type" => "country"
        }

  """
  def get_country_by_iso_alpha_3(country_code, index \\ "freedomhouse.org")

  def get_country_by_iso_alpha_3(country_code, "freedomhouse.org") do
    Map.get(@freedomhouse_org_dataset_alpha_3, country_code)
  end

  @doc """
  Gets the freedom index entry for a country based on ISO-3166 country name in English.

  ## Examples

      iex> FreedomIndices.get_country_by_iso_name("Sweden")
      %{
          "aggregate_score" => 100,
          "civil_liberties_rating" => 1,
          "combined_score" => 1,
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/report/freedom-world/2019/sweden",
          "type" => "country"
        }

  """
  def get_country_by_iso_name(country_name, source \\ "freedomhouse.org")

  def get_country_by_iso_name(country_name, "freedomhouse.org") do
    Map.get(@freedomhouse_org_dataset_name, country_name)
  end
end
