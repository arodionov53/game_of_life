# rle-parser Specification

## Purpose

Parses Run Length Encoded (.rle) pattern files into cell coordinate sets that the simulation engine can use.

## Requirements

### Requirement: Parse RLE encoded cell data
The parser SHALL decode RLE-encoded lines where `b` represents a dead cell, `o` represents an alive cell, `$` ends a row, and `!` terminates the pattern.

#### Scenario: Simple glider pattern
- **WHEN** parsing the RLE data `bo$2bo$3o!`
- **THEN** the result contains alive cells at (1,0), (2,1), (0,2), (1,2), (2,2)

#### Scenario: Run-length prefix
- **WHEN** parsing `3o!`
- **THEN** the result contains alive cells at (0,0), (1,0), (2,0)

#### Scenario: Multi-row pattern
- **WHEN** parsing `o$o$o!`
- **THEN** the result contains alive cells at (0,0), (0,1), (0,2)

### Requirement: Parse RLE header
The parser SHALL extract grid dimensions from the header line in the format `x = <width>, y = <height>`.

#### Scenario: Standard header
- **WHEN** the file contains the header `x = 3, y = 3`
- **THEN** the parsed metadata includes width 3 and height 3

### Requirement: Parse comment lines
The parser SHALL extract pattern name and other metadata from comment lines starting with `#`.

#### Scenario: Name comment
- **WHEN** the file contains `#N Glider`
- **THEN** the parsed metadata includes the name "Glider"

#### Scenario: Comment lines are skipped during cell parsing
- **WHEN** the file contains comment lines followed by the header and cell data
- **THEN** comment lines do not affect the parsed cell coordinates

### Requirement: Read RLE files from disk
The parser SHALL read `.rle` files from a given file path and return the parsed result.

#### Scenario: Valid file
- **WHEN** a valid `.rle` file exists at the given path
- **THEN** the parser returns the parsed cells and metadata

#### Scenario: Missing file
- **WHEN** the file does not exist at the given path
- **THEN** the parser returns an error indicating the file was not found

#### Scenario: Malformed RLE content
- **WHEN** the file contains invalid RLE data (missing `!` terminator, invalid characters)
- **THEN** the parser returns an error describing the parse failure

### Requirement: Whitespace tolerance
The parser SHALL ignore whitespace (spaces, tabs, newlines) within the RLE data section, treating the encoded data as a continuous stream.

#### Scenario: Line-wrapped RLE data
- **WHEN** the RLE data is split across multiple lines (as common in LifeWiki exports)
- **THEN** the parser produces the same result as if it were on a single line
