defmodule FreedomIndices do
  @moduledoc """
  Documentation for FreedomIndices.
  """

  @iso_country_code_alpha_2 "iso_country_code_alpha_2"
  @iso_country_code_alpha_3 "iso_country_code_alpha_3"
  @iso_country_code "iso_country_code"

  @freedomhouse_org_json_file "priv/freedomhouse.org.2020.json"
  @freedomhouse_org_json File.read!(@freedomhouse_org_json_file)

  @country_iso_codes_file "priv/country_iso_codes.json"
  @country_iso_codes File.read!(@country_iso_codes_file)
                     |> Jason.decode!()
                     |> Enum.reduce(%{}, fn e, acc ->
                       Map.put(acc, e["name"], e)
                     end)

  @freedomhouse_org_dataset Jason.decode!(@freedomhouse_org_json)
                            |> Enum.map(fn e ->
                              country_codes = Map.get(@country_iso_codes, e["name"])

                              ref =
                                "https://freedomhouse.org/country/#{Macro.underscore(e["name"])}/freedom-world/2020"

                              if country_codes do
                                e
                                |> Map.put(
                                  @iso_country_code_alpha_2,
                                  country_codes["alpha-2"]
                                )
                                |> Map.put(
                                  @iso_country_code_alpha_3,
                                  country_codes["alpha-3"]
                                )
                                |> Map.put(@iso_country_code, country_codes["country-code"])
                                |> Map.put("ref", ref)
                              else
                                e
                              end
                            end)

  @freedomhouse_org_dataset_alpha_2 @freedomhouse_org_dataset
                                    |> Enum.filter(fn x -> x["type"] == "country" end)
                                    |> Enum.reduce(%{}, fn x, acc ->
                                      Map.put(acc, x[@iso_country_code_alpha_2], x)
                                    end)

  @freedomhouse_org_dataset_alpha_3 @freedomhouse_org_dataset
                                    |> Enum.filter(fn x -> x["type"] == "country" end)
                                    |> Enum.reduce(%{}, fn x, acc ->
                                      Map.put(acc, x[@iso_country_code_alpha_3], x)
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
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/country/sweden/freedom-world/2020",
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
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/country/sweden/freedom-world/2020",
          "type" => "country"
        }

      iex> FreedomIndices.get_country_by_iso_alpha_3("SWE", "freedomhouse.org")
      %{
          "aggregate_score" => 100,
          "civil_liberties_rating" => 1,
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/country/sweden/freedom-world/2020",
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
          "freedom_status" => "Free",
          "iso_country_code" => "752",
          "iso_country_code_alpha_2" => "SE",
          "iso_country_code_alpha_3" => "SWE",
          "name" => "Sweden",
          "political_rights_rating" => 1,
          "ref" => "https://freedomhouse.org/country/sweden/freedom-world/2020",
          "type" => "country"
        }

  """
  def get_country_by_iso_name(country_name, source \\ "freedomhouse.org")

  def get_country_by_iso_name(country_name, "freedomhouse.org") do
    Map.get(@freedomhouse_org_dataset_name, country_name)
  end
end
