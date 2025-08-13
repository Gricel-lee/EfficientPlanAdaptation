// --- DOM Elements ---
const app = document.getElementById('app');
const problemsListView = document.getElementById('problems-list-view');
const problemDetailView = document.getElementById('problem-detail-view');
const problemsContainer = document.getElementById('problems-container');
const backButton = document.getElementById('back-button');
const loadingSpinner = document.getElementById('loading-spinner');
const confirmationModal = document.getElementById('confirmation-modal');
const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
const cancelDeleteBtn = document.getElementById('cancel-delete-btn');
const createProblemForm = document.getElementById('create-problem-form');
const createProblemBtn = document.getElementById('create-problem-btn');
const plotLoadingView = document.getElementById('plot-loading-view');
const plotErrorView = document.getElementById('plot-error-view');
const plotChartView = document.getElementById('plot-chart-view');
const plotLoadingStatus = document.getElementById('plot-loading-status');
const plotErrorTitle = document.getElementById('plot-error-title');
const plotErrorMessage = document.getElementById('plot-error-message');


// --- State ---
let chartInstance = null; // To hold the Chart.js instance
let problemIdToDelete = null; // To hold the ID of the problem to be deleted
let detailViewInterval = null; // To hold the polling interval for the detail view
let listViewInterval = null; // To hold the polling interval for the list view

// --- API Functions ---

async function createProblem(description, jsonFilePath) {
    createProblemBtn.disabled = true;
    createProblemBtn.textContent = 'Creating...';
    try {
        const response = await fetch('/api/problems/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ description: description, json_file: jsonFilePath })
        });
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        createProblemForm.reset();
        fetchAllProblems();
    } catch (error) {
        console.error("Failed to create problem:", error);
        alert('Failed to create problem. Check console for details.');
    } finally {
        createProblemBtn.disabled = false;
        createProblemBtn.textContent = 'Create Problem';
    }
}

async function fetchAllProblems() {
    if (!problemsContainer.innerHTML.trim() && loadingSpinner) {
        loadingSpinner.classList.remove('hidden');
    }
    
    try {
        // To ensure the browser fetches fresh data for status updates, we explicitly tell it not to use its cache for this request.
        const response = await fetch('/api/problems/', {
            cache: 'no-store', // Or 'reload'
            headers: {
                'Cache-Control': 'no-cache',
                'Pragma': 'no-cache'
            }
        });
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const problems = await response.json();
        renderProblemsList(problems);
    } catch (error) {
        console.error("Failed to fetch problems:", error);
        problemsContainer.innerHTML = `<p class="text-red-500 col-span-full">Failed to load problems. Make sure the API is running.</p>`;
    } finally {
        if(loadingSpinner) loadingSpinner.classList.add('hidden');
    }
}

async function fetchProblemById(problemId) {
    try {
        const response = await fetch(`/api/problems/${problemId}`);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const problem = await response.json();
        renderProblemDetail(problem);
    } catch (error) {
        console.error(`Failed to fetch problem ${problemId}:`, error);
        if (detailViewInterval) clearInterval(detailViewInterval);
    }
}


async function fetchPlotData(problemId) {
    try {
        const response = await fetch(`/api/problems/${problemId}/results`);
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ detail: 'Could not parse error response.' }));
            throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
        }
        const plotData = await response.json();
        
        if (plotData.x_values && plotData.y_values && plotData.x_label && plotData.y_label) {
            const scatterData = plotData.x_values.map((x, i) => ({ x: x, y: plotData.y_values[i] }));
            renderPlot(scatterData, plotData.x_label, plotData.y_label);
        } else {
            throw new Error("Invalid plot data format from API.");
        }

    } catch (error) {
        console.error("Failed to fetch or render plot data:", error);
        plotChartView.classList.add('hidden');
        plotErrorView.classList.remove('hidden');
        plotErrorTitle.textContent = "Plotting Error";
        plotErrorMessage.textContent = error.message;
    }
}

async function handleConfirmDelete() {
    if (!problemIdToDelete) return;
    try {
        const response = await fetch(`/api/problems/${problemIdToDelete}`, { method: 'DELETE' });
        if (!response.ok) {
            const errorData = await response.json().catch(() => null);
            throw new Error(`HTTP error! status: ${response.status}, detail: ${errorData?.detail}`);
        }
        fetchAllProblems();
    } catch (error) {
        console.error(`Failed to delete problem ${problemIdToDelete}:`, error);
        alert('Failed to delete problem. Check the console for details.');
    } finally {
        hideDeleteConfirmation();
    }
}

// --- Rendering Functions ---

function renderProblemsList(problems) {
    problemsContainer.innerHTML = '';
    if (problems.length === 0) {
        problemsContainer.innerHTML = `<p class="text-gray-500 col-span-full">No problems found. Create one.</p>`;
        return;
    }
    problems.sort((a, b) => new Date(b.date_creation) - new Date(a.date_creation));
    problems.forEach(problem => {
        const card = document.createElement('div');
        card.className = 'relative bg-white p-6 rounded-xl shadow-lg cursor-pointer transition-transform transform hover:-translate-y-1 hover:shadow-xl';
        card.dataset.id = problem.id;
        const statusColor = {
            created: 'bg-blue-100 text-blue-800',
            processing: 'bg-yellow-100 text-yellow-800 animate-pulse',
            completed: 'bg-green-100 text-green-800',
            failed: 'bg-red-100 text-red-800'
        }[problem.status] || 'bg-gray-100 text-gray-800';
        card.innerHTML = `
            <button class="delete-btn absolute top-3 right-3 p-1 text-gray-400 hover:text-red-600 hover:bg-red-100 rounded-full transition-colors focus:outline-none">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
            <div class="flex justify-between items-start mb-2">
                <h3 class="text-xl font-bold text-gray-800 truncate pr-8">${problem.description}</h3>
                <span class="text-xs font-semibold px-2.5 py-0.5 rounded-full ${statusColor}">${problem.status}</span>
            </div>
            <p class="text-sm text-gray-500 mb-4 font-mono">${problem.id}</p>
            <p class="text-sm text-gray-600">Created: ${new Date(problem.date_creation).toLocaleString()}</p>
        `;
        card.addEventListener('click', () => showDetailView(problem.id));
        const deleteButton = card.querySelector('.delete-btn');
        deleteButton.addEventListener('click', (event) => {
            event.stopPropagation();
            showDeleteConfirmation(problem.id);
        });
        problemsContainer.appendChild(card);
    });
}

function renderProblemDetail(problem) {
    if (detailViewInterval) clearInterval(detailViewInterval);
    document.getElementById('detail-title').textContent = problem.description;
    document.getElementById('detail-id').textContent = `ID: ${problem.id}`;
    document.getElementById('detail-log').innerHTML = `<pre>${JSON.stringify(problem, null, 2)}</pre>`;
    
    plotLoadingView.classList.add('hidden');
    plotErrorView.classList.add('hidden');
    plotChartView.classList.add('hidden');

    if (problem.status === 'created' || problem.status === 'processing') {
        plotLoadingStatus.textContent = `Status: ${problem.status}`;
        plotLoadingView.classList.remove('hidden');
        detailViewInterval = setInterval(() => fetchProblemById(problem.id), 3000);
    } else if (problem.status === 'failed') {
        plotErrorView.classList.remove('hidden');
        plotErrorTitle.textContent = "Processing Failed";
        plotErrorMessage.textContent = "Error. " + (problem.error_message || "An unknown error occurred.");
    } else if (problem.status === 'completed') {
        plotChartView.classList.remove('hidden');
        fetchPlotData(problem.id);
    } else {
        plotErrorView.classList.remove('hidden');
        plotErrorTitle.textContent = 'Unknown Status';
        plotErrorMessage.textContent = `The problem has an unrecognized status: ${problem.status}`;
    }
}

function renderPlot(data, xLabel, yLabel) {
    const ctx = document.getElementById('performance-chart').getContext('2d');
    if (chartInstance) chartInstance.destroy();
    chartInstance = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [{
                label: 'Pareto Front Results',
                data: data,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
            }]
        },
        options: {
            scales: {
                x: {
                    type: 'linear',
                    position: 'bottom',
                    title: {
                        display: true,
                        text: xLabel || 'Objective 1'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: yLabel || 'Objective 2'
                    }
                }
            },
            responsive: true,
            maintainAspectRatio: false
        }
    });
}

// --- View & Modal Switching Logic ---

function showListView() {
    if (detailViewInterval) clearInterval(detailViewInterval);
    if (listViewInterval) clearInterval(listViewInterval);

    problemDetailView.classList.add('hidden');
    problemsListView.classList.remove('hidden');
    
    fetchAllProblems();
    
    listViewInterval = setInterval(fetchAllProblems, 5000);
}

function showDetailView(problemId) {
    if (listViewInterval) clearInterval(listViewInterval);

    problemsListView.classList.add('hidden');
    problemDetailView.classList.remove('hidden');
    fetchProblemById(problemId);
}

function showDeleteConfirmation(problemId) {
    problemIdToDelete = problemId;
    confirmationModal.classList.remove('hidden');
}

function hideDeleteConfirmation() {
    problemIdToDelete = null;
    confirmationModal.classList.add('hidden');
}

// --- Event Listeners ---
backButton.addEventListener('click', showListView);
confirmDeleteBtn.addEventListener('click', handleConfirmDelete);
cancelDeleteBtn.addEventListener('click', hideDeleteConfirmation);
createProblemForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const description = document.getElementById('problem-description').value;
    const jsonFilePath = document.getElementById('problem-json-path').value;
    createProblem(description, jsonFilePath);
});

// --- Initial Load ---
document.addEventListener('DOMContentLoaded', () => {
    showListView();
});
