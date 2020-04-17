defmodule GoogleCrawler.FixtureHelper do
  @fixture_path "test/fixtures"

  def upload_file_fixture(path) do
    path = Path.join([@fixture_path, path])

    %Plug.Upload{
      content_type: MIME.from_path(path),
      filename: Path.basename(path),
      path: path
    }
  end
end
