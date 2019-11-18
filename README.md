# Small bioinfo containers

These containers are small (filesize) images for genomics/transcriptomics. Each
submodule provides one app:

- bschiffthaler/bcftools
- bschiffthaler/samtools
- bschiffthaler/bwa
- bschiffthaler/salmon
- bschiffthaler/kallisto
- bschiffthaler/fastqc
- bschiffthaler/trimmomatic
- bschiffthaler/bedtools

## Motivation

Docker is an excellent tool for bioinformatics as we often see users with very
limited exposure to Linux trying to use software that can be complex to install.
With reproducible research in mind, it also offers an excellent way to distribute
exact versions of tools as a supplement to the materials and methods. This is currently
severely hampered by multi-gigabyte images that provide a complex stack of libraries
in order to execute a single binary. Further, users may want to keep several versions of tools for compatibility, but these libraries can quickly grow to serveral hundred
GBs even with docker's smart storage drivers.

This project aims to build images that are as small as possible to allow docker to
be used more effectively on research compute systems (small or large) and to enable
better reproducible research so containers can be supplementary to materials and methods.

## Usage

These containers are typically intended to be run as exemplified:

```bash
docker run \
  --user=${UID}:${GID} \
  -v $(pwd):$(pwd) -w $(pwd) --rm \
  bschiffthaler/bwa ... # Further argument passed to bwa
```

Some containers may run differently, see READMEs in the sub-directories.

## Contributing

Pull requests are _very_ welcome. Contibuted Dockerfiles need to be based on
alpine and should follow the two image build procedure (see the `bwa` image as
an example). If dynamic libraries cannot be avoided, great care should be taken
in what is included in the final image.