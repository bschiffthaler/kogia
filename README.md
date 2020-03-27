# Small bioinfo containers

These containers are small (filesize) images for genomics/transcriptomics. Each
submodule provides one app.

If you find this useful in your research, please cite the DOI:
[![DOI](https://zenodo.org/badge/222556447.svg)](https://zenodo.org/badge/latestdoi/222556447)

Currently we have builds for:

### Alignment

- [bschiffthaler/bowtie](https://hub.docker.com/repository/docker/bschiffthaler/bowtie)
- [bschiffthaler/bwa](https://hub.docker.com/repository/docker/bschiffthaler/bwa)
- [bschiffthaler/diamond](https://hub.docker.com/repository/docker/bschiffthaler/diamond)
- [bschiffthaler/minimap2](https://hub.docker.com/repository/docker/bschiffthaler/minimap2)
- [bschiffthaler/ncbi-blast](https://hub.docker.com/repository/docker/bschiffthaler/ncbi-blast)

### Assembly

- [bschiffthaler/flye](https://hub.docker.com/repository/docker/bschiffthaler/flye)
- [bschiffthaler/spades](https://hub.docker.com/repository/docker/bschiffthaler/spades)
- [bschiffthaler/wtdbg2](https://hub.docker.com/repository/docker/bschiffthaler/wtdbg2)

### Population genomics

- [bschiffthaler/stacks](https://hub.docker.com/repository/docker/bschiffthaler/stacks)

### Pseudo-alignment/quantification

- [bschiffthaler/kallisto](https://hub.docker.com/repository/docker/bschiffthaler/kallisto)
- [bschiffthaler/salmon](https://hub.docker.com/repository/docker/bschiffthaler/salmon)

### QC/Read preprocessing

- [bschiffthaler/fastqc](https://hub.docker.com/repository/docker/bschiffthaler/fastqc)
- [bschiffthaler/multiqc](https://hub.docker.com/repository/docker/bschiffthaler/multiqc)
- [bschiffthaler/sortmerna](https://hub.docker.com/repository/docker/bschiffthaler/sortmerna)
- [bschiffthaler/trimmomatic](https://hub.docker.com/repository/docker/bschiffthaler/trimmomatic)

### Toolboxes

- [bschiffthaler/bcftools](https://hub.docker.com/repository/docker/bschiffthaler/bcftools)
- [bschiffthaler/bedtools](https://hub.docker.com/repository/docker/bschiffthaler/bedtools)
- [bschiffthaler/samtools](https://hub.docker.com/repository/docker/bschiffthaler/samtools)


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

Alternatively there are simple bash scripts in the `/scripts` directory that
wrap the docker images and allow users to call them very similaly to a native CLI
application. As an example:

```bash
<kogia_root>/scripts/samtools index GRCh38.fa
```

Some containers may run differently, see READMEs in the sub-directories.

## Contributing

Pull requests are _very_ welcome. Contibuted Dockerfiles need to be based on
alpine and should follow the two image build procedure (see the `bwa` image as
an example).
