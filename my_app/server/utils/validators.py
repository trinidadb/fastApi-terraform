from pydantic import BaseModel, model_validator
from server.constants import MeatType, CutView


class ImageMetaValidator(BaseModel):
    meat_type: MeatType
    cut_view: CutView

    @model_validator(mode="after")
    def check_meat_view_combination(self):
        allowed = {
            MeatType.lomo: {CutView.front},
            MeatType.jamon: {CutView.top, CutView.side},
        }

        if self.meat_type in allowed and self.cut_view not in allowed[self.meat_type]:
            allowed_str = ', '.join(v.value for v in allowed[self.meat_type])
            raise ValueError(
                f"View '{self.cut_view.value}' not allowed for meat type '{self.meat_type.value}'. "
                f"Allowed views: {allowed_str}"
            )
        return self
