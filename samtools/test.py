#!/usr/bin/env python3

from avocado import Test
from avocado.utils import process
import os

EXE="samtools.sif"
BAM="samtools/test/dat/test_input_1_a.bam"

class BasicTests(Test):

	def setUp(self):
		self.sexe = self.get_data(EXE)
		if self.sexe is None:
			self.fail(f"Test is missing data file {EXE}")

		self.bam = self.get_data(BAM)
		if self.bam is None:
			self.fail(f"Test is missing data file {BAM}")

	def test_version(self):
		process.run(" ".join([self.sexe, "version"]))

	def test_view(self):
		process.run(" ".join([self.sexe, "view", self.bam]))

	def test_sort(self):
		process.run(" ".join([self.sexe, "sort", self.bam]))

