package com.esa.maap.model.roi.featurecollection;

import java.util.Map;
import java.util.Objects;

public class Feature {
	private int id;

	private Map<String, String> attributeTable = null;

	public Feature(int id, Map<String, String> attributeTable) {
		super();
		this.id = id;
		this.attributeTable = attributeTable;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Map<String, String> getAttributeTable() {
		return attributeTable;
	}

	public void setAttributeTable(Map<String, String> attributeTable) {
		this.attributeTable = attributeTable;
	}


	
	
	@Override
	  public boolean equals(java.lang.Object o) {
	    if (this == o) {
	      return true;
	    }
	    if (o == null || getClass() != o.getClass()) {
	      return false;
	    }
	    Feature feature = (Feature) o;
	    return Objects.equals(this.id, feature.id) &&
	        Objects.equals(this.attributeTable, feature.attributeTable);
	  }

	  @Override
	  public int hashCode() {
	    return Objects.hash(id, attributeTable);
	  }

	  @Override
	  public String toString() {
	    StringBuilder sb = new StringBuilder();
	    sb.append("class Feature {\n");
	    
	    sb.append("    id: ").append(toIndentedString(id)).append("\n");
	    sb.append("    attributeTable: ").append(toIndentedString(attributeTable)).append("\n");
	    sb.append("}");
	    return sb.toString();
	  }

	  /**
	   * Convert the given object to string with each line indented by 4 spaces
	   * (except the first line).
	   */
	  private String toIndentedString(java.lang.Object o) {
	    if (o == null) {
	      return "null";
	    }
	    return o.toString().replace("\n", "\n    ");
	  }



}
