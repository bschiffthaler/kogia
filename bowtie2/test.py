#!/usr/bin/env python3

from avocado import Test
from avocado.utils import process
import os

EXE="bowtie2.sif"

class BasicTests(Test):

	def setUp(self):
		self.sexe = self.get_data(EXE)
		if self.sexe is None:
			self.fail(f"Test is missing data file {EXE}")

	def test_version(self):
		process.run(" ".join([self.sexe, "--version"]))
