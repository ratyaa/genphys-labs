TEX =			pdflatex
TEX_FLAGS =		--interaction=batchmode --output-directory $(BUILD_DIR) -shell-escape
PLT =			gnuplot
PLT_FLAGS =		-e "includedir = '../$(PLT_INCLUDE_DIR)/';\
			outdir = '../$(PIC_DIR)/';\
			datadir = '../$(DATA_DIR)/';"\
			../$(PLT_INCLUDE_DIR)/default.gp
PDF_READER =		zathura
PDF_READER_FLAGS =
SEM_DIR	=		../../sem/

TABLES_SRC =		tables.org\
			scripts/tangle-tables.el\
			scripts/ProcessTables.jl
TABLES_TARGET =		data/main.csv

PLT_DIR =		plt
PIC_DIR =		pic
TEX_DIR =		tex
DATA_DIR =		data
PDF_DIR =		../../pdf
PLT_INCLUDE_DIR =	plt/include
TEX_SRC =		$(wildcard $(TEX_DIR)/*.tex)\
			$(wildcard $(TEX_DIR)/tables/*.tex)
PLT_SRC =		$(wildcard $(PLT_DIR)/*.gp)
PLT_INCLUDE_SRC =	$(wildcard $(PLT_INCLUDE_DIR)/*.gp)
BUILD_DIR =		.build

NAME :=			$(shell basename $(CURDIR))
PLT_TARGET =		$(PLT_SRC:$(PLT_DIR)%.gp=$(PIC_DIR)%.svg)
TEX_TARGET =		$(PDF_DIR)/$(NAME).pdf

.PHONY: build clean read
.DEFAULT_GOAL :=	build

clean:
	rm -rf $(PIC_DIR) $(BUILD_DIR) $(PDF_DIR)/$(NAME).pdf svg-inkscape $(DATA_DIR)

# Open homework file
readh:
ifneq ($(wildcard $(PDF_DIR)/$(NAME).pdf),)
	$(PDF_READER) $(PDF_READER_FLAGS) $(PDF_DIR)/$(NAME).pdf &
else
	@echo "File does not exist."
endif

# Open seminar outline
reado:
ifneq ($(wildcard $(SEM_DIR)/$(NAME).pdf),)
	$(PDF_READER) $(PDF_READER_FLAGS) $(SEM_DIR)/$(NAME).pdf &
else
	@echo "File does not exist."
endif

build: $(TABLES_TARGET) $(PLT_TARGET) $(TEX_TARGET)

$(TABLES_TARGET): $(TABLES_SRC)
	@mkdir -p data
	@mkdir -p .build
	emacs --script scripts/tangle-tables.el
	julia scripts/ProcessTables.jl

plt/*.gp: $(PLT_INCLUDE_SRC) $(TABLES_TARGET)
	@touch $@

pic/%.svg: plt/%.gp
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(PIC_DIR)
	@find -type f -name "*.fitlog" | xargs -i rm "/tmp/pivo" {}

ifneq ($(PLT_SRC),)
	@cd $(BUILD_DIR) && $(PLT) $(PLT_FLAGS) ../$^
endif

$(TEX_TARGET): $(TEX_SRC) $(PLT_TARGET)
	@mkdir -p $(BUILD_DIR)
	$(TEX) $(TEX_FLAGS) $(TEX_DIR)/main.tex 2>&1 /dev/null
	$(TEX) $(TEX_FLAGS) $(TEX_DIR)/main.tex 2>&1 /dev/null
	@cp $(BUILD_DIR)/main.pdf $(PDF_DIR)/$(NAME).pdf
