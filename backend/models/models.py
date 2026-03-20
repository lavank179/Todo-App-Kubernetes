from sqlalchemy.orm import Mapped, mapped_column
from utils.db import Base
import uuid
from sqlalchemy import UUID

class Task(Base):
    __tablename__ = "tasks"  # Must match your existing SQL table name

    # If the UI sends an ID, it uses that. 
    # SQLAlchemy will now automatically cast strings to UUIDs for Postgres
    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), 
        primary_key=True, 
        default=uuid.uuid4
    )
    task: Mapped[str]
    completed: Mapped[bool] = mapped_column(default=False)
