"""Apple Quartile Solver - Streamlit Web Interface.

This module provides a web-based user interface for the Apple Quartile puzzle solver.
It uses Streamlit to create an interactive application that allows users to input
puzzle tiles and find valid English words from the WordNet dictionary.

Usage:
    streamlit run app.py
"""

import time
from pathlib import Path
from typing import Tuple

import streamlit as st

from solver import load_dictionary, solve_puzzle, parse_puzzle_input, validate_puzzle
from solver.trie import TrieNode

# Page configuration
st.set_page_config(
    page_title="Apple Quartile Solver",
    page_icon="🔤",
    layout="wide",
    initial_sidebar_state="collapsed",
)

# Custom CSS
st.markdown(
    """
<style>
    .main {
        background-color: #F2F2F7;
    }
    /* Force dark text on all elements */
    .stMarkdown, .stMarkdown p, .stMarkdown h1, .stMarkdown h2, .stMarkdown h3,
    .stMarkdown h4, .stMarkdown h5, .stMarkdown h6, .stMarkdown li, .stMarkdown span,
    .stTextInput label, .stTextArea label, .stSelectbox label, div[data-testid="stMarkdownContainer"] {
        color: #1C1C1E !important;
    }
    .stButton>button {
        background-color: #007AFF;
        color: white !important;
        border-radius: 8px;
        padding: 12px 24px;
        font-weight: 600;
        border: none;
    }
    .stButton>button:hover {
        background-color: #0051D5;
    }
    .result-card {
        background-color: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        border: 1px solid #E5E5EA;
    }
    .stat-box {
        background-color: #F2F2F7;
        padding: 12px;
        border-radius: 8px;
        margin: 8px 0;
    }
    /* Ensure text areas and inputs have dark text and visible borders */
    .stTextArea textarea, .stTextInput input {
        color: #1C1C1E !important;
        border: 2px solid #C7C7CC !important;
        background-color: white !important;
    }
    .stTextArea textarea:focus, .stTextInput input:focus {
        border-color: #007AFF !important;
    }
    /* Fix selectbox borders */
    .stSelectbox > div > div {
        border: 2px solid #C7C7CC !important;
        background-color: white !important;
    }
    /* Fix caption text */
    .stCaption {
        color: #6C6C70 !important;
    }
</style>
""",
    unsafe_allow_html=True,
)

# Sample puzzles
SAMPLE_PUZZLES = {
    "Puzzle 1": (
        "dis\ncre\nti\non\nuns\ncra\nmb\nles\norn\nit\nhol\nogy\n"
        "pro\nve\nrb\nial\nga\nte\nkee\nping"
    ),
    "Puzzle 2": (
        "per\niwi\nnk\nle\nju\ndgm\nent\nal\ntoa\nst\nmas\nter\n"
        "sy\nmpa\nthi\nzed\nspli\nnt\neri\nng"
    ),
    "Puzzle 3": (
        "ma\npur\ncha\nbib\nwi\nrshm\npor\nnn\nlio\nse\nall\nted\n"
        "eli\nph\ncra\now\nly\nng\nile\ncked"
    ),
    "Puzzle 4": (
        "hyd\ngra\nal\nsc\nhori\nran\nss\nto\nand\nzo\nge\nroo\n"
        "get\nali\nnta\nas\nts\nher\nzed\nlly"
    ),
    "Puzzle 5": (
        "et\nci\nway\nve\nma\nent\nsa\nrcum\ning\nnts\nomp\nmes\n"
        "pas\nriz\nme\nce\ninc\npea\nge\nker"
    ),
}


@st.cache_resource
def initialize_dictionary() -> Tuple[TrieNode, int]:
    """Load the WordNet dictionary and cache it for reuse.

    This function loads the dictionary once and caches it using Streamlit's
    cache_resource decorator to avoid reloading on each page refresh.

    Returns:
        Tuple containing:
            - TrieNode: The populated trie data structure
            - int: The number of words loaded into the dictionary

    Raises:
        SystemExit: If the dictionary file is not found.
    """
    dictionary_path = Path(__file__).parent.parent / "prolog" / "wn_s.pl"

    if not dictionary_path.exists():
        st.error(f"Dictionary file not found: {dictionary_path}")
        st.stop()

    with st.spinner("Loading dictionary..."):
        trie, word_count = load_dictionary(str(dictionary_path))

    return trie, word_count


def main() -> None:
    """Run the Streamlit web application.

    This is the main entry point for the Streamlit app. It initializes the
    dictionary, renders the UI components, and handles user interactions
    for solving Quartile puzzles.
    """
    # Initialize dictionary
    trie, dict_word_count = initialize_dictionary()

    # Header
    st.title("🔤 Apple Quartile Solver")
    st.caption(f"Dictionary loaded: {dict_word_count:,} words")

    # Layout
    col1, col2 = st.columns([4, 6])

    with col1:
        st.subheader("Puzzle Input")

        # Sample puzzle selector
        sample_choice = st.selectbox(
            "Load Sample Puzzle",
            [""] + list(SAMPLE_PUZZLES.keys()),
            index=0,
        )

        # Puzzle input
        default_text = SAMPLE_PUZZLES.get(sample_choice, "")
        puzzle_input = st.text_area(
            "Enter puzzle tiles (one per line)",
            value=default_text,
            height=300,
            placeholder="Example:\ndis\ncre\nti\non",
            help="Enter each puzzle tile on a separate line",
        )

        # Action buttons
        col_solve, col_clear = st.columns([3, 1])

        with col_solve:
            solve_button = st.button("🎯 Solve Puzzle", use_container_width=True)

        with col_clear:
            if st.button("Clear", use_container_width=True):
                st.rerun()

    with col2:
        st.subheader("Results")

        if solve_button:
            # Parse and validate input
            tiles = parse_puzzle_input(puzzle_input)
            is_valid, error_msg = validate_puzzle(tiles)

            if not is_valid:
                st.error(f"❌ {error_msg}")
            else:
                # Solve puzzle
                start_time = time.time()
                words, perms_checked = solve_puzzle(tiles, trie)
                elapsed_time = time.time() - start_time

                # Display results
                if words:
                    # Statistics
                    st.markdown(
                        f"""
                    <div class="stat-box">
                        <strong>{len(words)} words found</strong><br>
                        <small>Processed in {elapsed_time*1000:.0f}ms • """
                        f"""{perms_checked:,} permutations checked</small>
                    </div>
                    """,
                        unsafe_allow_html=True,
                    )

                    # Sort options
                    sort_option = st.radio(
                        "Sort by",
                        ["Original", "Alphabetical", "Length (longest first)"],
                        horizontal=True,
                    )

                    # Sort words
                    if sort_option == "Alphabetical":
                        display_words = sorted(words)
                    elif sort_option == "Length (longest first)":
                        display_words = sorted(words, key=lambda w: (-len(w), w))
                    else:
                        display_words = words

                    # Export buttons
                    col_copy, col_export = st.columns(2)
                    with col_copy:
                        words_text = "\n".join(f"{i+1}. {w}" for i, w in enumerate(display_words))
                        st.download_button(
                            "📋 Copy Results",
                            words_text,
                            file_name="quartile_results.txt",
                            use_container_width=True,
                        )

                    # Display words
                    st.markdown("---")

                    # Create scrollable list
                    words_html = "<div style='max-height: 500px; overflow-y: auto;'>"
                    for i, word in enumerate(display_words):
                        bg_color = "#FFFFFF" if i % 2 == 0 else "#FAFAFA"
                        words_html += f"""
                        <div style='background-color: {bg_color}; padding: 8px 16px;
                                    border-bottom: 1px solid #E5E5EA;'>
                            {i+1}. {word}
                        </div>
                        """
                    words_html += "</div>"

                    st.markdown(words_html, unsafe_allow_html=True)
                else:
                    st.warning("No words found for this puzzle.")
        else:
            st.info("👈 Enter puzzle tiles and click 'Solve Puzzle' to see results")


if __name__ == "__main__":
    main()
