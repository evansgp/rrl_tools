# RRL Import

A script that imports the [ACMA Spectra RRL](https://www.acma.gov.au/radiocomms-licence-data) into an [SQLite3](https://www.sqlite.org/) database for later querying.

## Usage

```
./import.sh
```

# Localised transmitters

Queries the imported ACMA data with a (very rough) bounding box and frequency range so that you can view transmitters in an area.

## Usage

Open [google maps](https://maps.google.com), navigate to the centre of the area you want to search, right click and then click on the coordinates to copy to your clipboard.

```
./localised_transmitters.sh
```

Paste in the coordinates, search distance and frequency range.

A CSV (`localised_transmitters_output.csv`) is emitted that can be imported to whatever for nicer viewing.

# Dependencies

* bash
* unzip
* curl
* sqlite3

# Acknowledgements

Thanks to [Gwyn Hannay](https://github.com/GwynHannay) for contributing all of the database logic/functionality.
Thanks to [kronicd](https://github.com/kronicd/) for the import functionality.