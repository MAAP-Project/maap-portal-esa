package com.esa.maap.algorithm.api;

import com.esa.bmap.model.Algorithm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlgoTopicDto {

	private Map<String, List<String>> listOfTopics = new HashMap<>();
	private List<Algorithm> algoList = new ArrayList<>();
	
	
	/**
	 * Constructor with fields
	 * @param listOfTopics
	 * @param algoList
	 */
	public AlgoTopicDto(Map<String, List<String>> listOfAlgoByTopic, List<Algorithm> algoList) {
		super();
		this.listOfTopics = listOfAlgoByTopic;
		this.algoList = algoList;
	}


	public Map<String, List<String>> getListOfTopics() {
		return listOfTopics;
	}


	public void setListOfTopics(Map<String, List<String>> listOfTopics) {
		this.listOfTopics = listOfTopics;
	}


	public List<Algorithm> getAlgoList() {
		return algoList;
	}


	public void setAlgoList(List<Algorithm> algoList) {
		this.algoList = algoList;
	}
	
	
	
}
